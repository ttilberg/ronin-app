# frozen_string_literal: true
#
# ronin-app - a local web app for Ronin.
#
# Copyright (C) 2023 Hal Brodigan (postmodern.mod3@gmail.com)
#
# ronin-app is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-app is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with ronin-app.  If not, see <http://www.gnu.org/licenses/>.
#

require 'sidekiq'

require 'schemas/spider_params'

require 'ronin/web/spider'

module Workers
  #
  # Web spider worker.
  #
  class Spider

    include Sidekiq::Worker
    sidekiq_options queue: :spider, retry: false, backtrace: true

    Params = Dry::Schema::JSON(parent: Schemas::SpiderParams)

    #
    # Processes a web spider job.
    #
    # @param [Hash{String => Object}] params
    #   The JSON deserialized params for the job.
    #
    # @raise [ArgumentError]
    #   The params could not be validated or coerced.
    #
    def perform(params)
      params = validate(params)
      type   = params.delete(:type)
      target = params.delete(:target)

      spider(type,target,**params) do |agent|
        agent.every_page do |page|
          import_url(page.url)
        end
      end
    end

    #
    # Validates the given job params.
    #
    # @param [Hash{String => Object}] params
    #   The JSON deserialized params for the job.
    #
    # @return [Hash{Symbol => Object}]
    #   The validated and coerced params as a Symbol Hash.
    #
    # @raise [ArgumentError]
    #   The params could not be validated or coerced.
    #
    def validate(params)
      result = Params.call(params)

      if result.failure?
        raise(ArgumentError,"invalid spider params (#{params.inspect}): #{result.errors.inspect}")
      end

      return result.to_h
    end

    #
    # Spiders a host, domain, or site.
    #
    # @param ["host", "domain", "site"] type
    #   Indicates whether to spider a host, domain, or site.
    #
    # @param [String] target
    #   The host name, domain name, or website base URL to spider.
    #
    # @yield [agent]
    #   The given block will be yielded the new web spider agent to configure.
    #
    # @yieldparam [Ronin::Web::Spider::Agent] agent
    #   The new web spider agent.
    #
    def spider(type,target,**kwargs,&block)
      case type
      when 'host'   then Ronin::Web::Spider.host(target,**kwargs,&block)
      when 'domain' then Ronin::Web::Spider.domain(target,**kwargs,&block)
      when 'site'   then Ronin::Web::Spider.site(target,**kwargs,&block)
      end
    end

    #
    # Imports a URL.
    #
    # @param [String, URI::HTTP] url
    #   The URL or URI to import.
    #
    def import_url(url)
      Ronin::DB::URL.transaction do
        Ronin::DB::URL.import(url)
      end
    end

  end
end
