require 'helper'
require "data_mapper"

DataMapper.setup(:default, 'postgres://testuser:testuserpass@localhost/test')
DataMapper.finalize

class TestGeneralDB < MiniTest::Unit::TestCase
  def setup
    @db = Bio::Chado::General::DB.create
    DataMapper.auto_migrate!
  end

  def test_db_class
    assert_equal @db.class, Bio::Chado::General::DB
  end

  def test_dbxref_properties
    @db.name = "test"
    @db.description = "A simple test database"
    @db.urlprefix = "http://www.example.com"
  end
end

