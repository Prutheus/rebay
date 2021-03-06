module Rebay
  class Finding < Rebay::Api
    def self.base_url_suffix
      'ebay.com/services/search/FindingService/v1'
    end

    VERSION = '1.0.0'.freeze

    # http://developer.ebay.com/DevZone/finding/CallRef/findItemsAdvanced.html
    def find_items_advanced(params)
      raise ArgumentError unless params[:keywords] || params[:categoryId]
      response = get_json_response(build_request_url('findItemsAdvanced', params))
      response.trim(:findItemsAdvancedResponse)

      if response.response.key?('searchResult') && response.response['searchResult'].key?('item')
        response.results = response.response['searchResult']['item']
      end
      response
    end

    # http://developer.ebay.com/DevZone/finding/CallRef/findItemsByCategory.html
    def find_items_by_category(params)
      raise ArgumentError unless params[:categoryId]
      response = get_json_response(build_request_url('findItemsByCategory', params))
      response.trim(:findItemsByCategoryResponse)
      if response.response.key?('searchResult') && response.response['searchResult'].key?('item')
        response.results = response.response['searchResult']['item']
      end
      response
    end

    # http://developer.ebay.com/DevZone/finding/CallRef/findItemsByKeywords.html
    def find_items_by_keywords(params)
      raise ArgumentError unless params[:keywords]
      response = get_json_response(build_request_url('findItemsByKeywords', params))
      response.trim(:findItemsByKeywordsResponse)
      if response.response.key?('searchResult') && response.response['searchResult'].key?('item')
        response.results = response.response['searchResult']['item']
      end
      response
    end

    # http://developer.ebay.com/DevZone/finding/CallRef/findItemsByProduct.html
    def find_items_by_product(params)
      raise ArgumentError unless params[:productId]
      params['productId.@type'] = 'ReferenceID'
      response = get_json_response(build_request_url('findItemsByProduct', params))
      response.trim(:findItemsByProductResponse)
      if response.response.key?('searchResult') && response.response['searchResult'].key?('item')
        response.results = response.response['searchResult']['item']
      end
      response
    end

    # http://developer.ebay.com/DevZone/finding/CallRef/findItemsIneBayStores.html
    def find_items_in_ebay_stores(params)
      raise ArgumentError unless params[:keywords] || params[:storeName]
      response = get_json_response(build_request_url('findItemsIneBayStores', params))
      response.trim(:findItemsIneBayStoresResponse)
      if response.response.key?('searchResult') && response.response['searchResult'].key?('item')
        response.results = response.response['searchResult']['item']
      end
      response
    end

    # http://developer.ebay.com/DevZone/finding/CallRef/getHistograms.html
    def get_histograms(params)
      raise ArgumentError unless params[:categoryId]
      response = get_json_response(build_request_url('getHistograms', params))
      response.trim(:getHistorgramsResponse)
      response
    end

    # http://developer.ebay.com/DevZone/finding/CallRef/getSearchKeywordsRecommendation.html
    def get_search_keywords_recommendation(params)
      raise ArgumentError unless params[:keywords]
      response = get_json_response(build_request_url('getSearchKeywordsRecommendation', params))
      response.trim(:getSearchKeywordsRecommendationResponse)
      if response.response.key?('keywords')
        response.results = response.response['keywords']
      end
      response
    end

    # http://developer.ebay.com/DevZone/finding/CallRef/getVersion.html
    def get_version
      response = get_json_response(build_request_url('getVersion'))
      response.trim(:getVersionResponse)
      if response.response.key?('version')
        response.results = response.response['version']
      end
      response
    end

    private

    def build_request_url(service, params = nil)
      url = "#{self.class.base_url}?OPERATION-NAME=#{service}&SERVICE-VERSION=#{VERSION}&SECURITY-APPNAME=#{Rebay::Api.app_id}&RESPONSE-DATA-FORMAT=JSON&GLOBAL-ID=#{params[:global_id]}&REST-PAYLOAD"
      url += build_rest_payload(params)
      url
    end
  end
end
