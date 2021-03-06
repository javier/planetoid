require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  
  def test_fixtures
    Project.find(:all).each do |p|
      assert p.valid?
    end
  end
  
  def test_required_fields
    p = Project.new
    assert !p.valid?
    assert p.errors.on(:name)
    assert p.errors.on(:url)
    
    p.name = "An interesting project"
    p.url = "http://www.example.com/newprojectinteresting"
    assert p.valid?
    assert !p.errors.on(:name)
    assert !p.errors.on(:url)
  end
  
  def test_format_of_url
    # http://en.wikipedia.org/wiki/Hostname#Restrictions_on_valid_host_names
    # RFCs mandate that a hostname's labels may contain only the ASCII letters 'a' through 'z' (case-insensitive), the digits '0' through '9', and the hyphen.
    # Hostname labels cannot begin or end with a hyphen. No other symbols, punctuation characters, or blank spaces are permitted.
    
    p = Project.new(:name => 'An interesting project', :url => 'http://www.validurl.com')
    assert p.valid?
    
    ['http://www.example.com', 'http://www.example-with-hyphens.com', 'http://www.example.com/with/subdirs/'].each do |address|
      p.url = address
      assert p.valid?
    end
    
    [nil, '', 'badaddress', 'email@example.com', 'ftp://example.com', 'http://www.example_with_underscore.com', 'http://www.-example.com', 'http://www.example-.com', 'nohttp.com', 'www.nohttp.com', 'http://www.we have spaces.com'].each do |address|
      p.url = address
      assert !p.valid?
    end
  end
  
  def test_should_validate_uniqueness_of_url
    p=Project.new(:name => 'An interesting project', :url => projects(:metainspector).url)
    assert !p.valid?
    assert p.errors.on(:url)
    p.url = 'http://www.example.com'
    assert p.valid?
  end
  
  def test_a_project_has_and_belongs_to_many_users
    assert_equal projects(:planetoid).users.size, 2
    [users(:jaime), users(:juan)].each do |user|
      assert projects(:planetoid).users.include?(user)
    end
    
    assert_equal users(:jaime).projects.size, 2
    [projects(:planetoid), projects(:metainspector)].each do |project|
      assert users(:jaime).projects.include?(project)
    end
  end
  
end
