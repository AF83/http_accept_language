require 'active_support'

module HttpAcceptLanguage
  extend ActiveSupport::Autoload
  autoload :AcceptLanguage
end

if defined?(ActionDispatch::Request)
  class ActionDispatch::Request
    include HttpAcceptLanguage::AcceptLanguage
  end
end
