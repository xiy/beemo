require "beemo/version"
require "beemo/scraper"

class Hash
  # Implementation of reverse_merge from Rails ActiveSupport.
  # http://api.rubyonrails.org/v2.3.8/classes/ActiveSupport/CoreExtensions/Hash/ReverseMerge.html
  def reverse_merge(other_hash)
    other_hash.merge(self)
  end

  def reverse_merge!(other_hash)
    replace(reverse_merge(other_hash))
  end

  alias_method :with_default, :reverse_merge
  alias_method :with_defaults, :reverse_merge
  alias_method :with_default!, :reverse_merge!
  alias_method :with_defaults!, :reverse_merge!
end
