if defined?(ChefSpec)

  ChefSpec.define_matcher(:nrpe_check)

  def add_nrpe_check(check)
    ChefSpec::Matchers::ResourceMatcher.new(:nrpe_check, :add, check)
  end

  def remove_nrpe_check(check)
    ChefSpec::Matchers::ResourceMatcher.new(:nrpe_check, :remove, check)
  end

end
