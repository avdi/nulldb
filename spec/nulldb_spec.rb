require 'rubygems'
require 'active_record'
$: << File.join(File.dirname(__FILE__), "..", "lib")

class Employee < ActiveRecord::Base
  after_save :on_save_finished

  def on_save_finished
  end
end

describe "NullDB" do
  before :all do
    ActiveRecord::Base.establish_connection :adapter => :nulldb
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Schema.define do
      create_table(:employees) do |t|
        t.string  :name
        t.date    :hire_date
        t.integer :employee_number
        t.decimal :salary
      end
    end
  end

  before :each do
    @employee =  Employee.new(:name           => "John Smith",
                             :hire_date       => Date.civil(2000, 1, 1),
                             :employee_number => 42,
                             :salary          => 56000.00)
  end

  it "should enable instantiation of AR objects without a database" do
    @employee.should_not be_nil
    @employee.should be_a_kind_of(ActiveRecord::Base)
  end

  it "should remember columns defined in migrations" do
    should_have_column(Employee, :name, :string)
    should_have_column(Employee, :hire_date, :date)
    should_have_column(Employee, :employee_number, :integer)
    should_have_column(Employee, :salary, :decimal)
  end

  it "should enable simulated saving of AR objects" do
    lambda { @employee.save! }.should_not raise_error
  end

  it "should enable AR callbacks during simulated save" do
    @employee.should_receive(:on_save_finished)
    @employee.save
  end

  it "should enable simulated deletes of AR objects" do
    lambda { @employee.destroy }.should_not raise_error
  end

  it "should enable simulated creates of AR objects" do
    emp = Employee.create(:name => "Bob Jones")
    emp.name.should == "Bob Jones"
  end

  it "should generate new IDs when inserting unsaved objects" do
    cxn = Employee.connection
    id1 = cxn.insert("some sql", "SomeClass Create", "id", nil, nil)
    id2 = cxn.insert("some sql", "SomeClass Create", "id", nil, nil)
    id2.should == (id1 + 1)
  end

  it "should re-use object ID when inserting saved objects" do
    cxn = Employee.connection
    id1 = cxn.insert("some sql", "SomeClass Create", "id", 23, nil)
    id1.should == 23
  end

  it "should log executed SQL statements" do
    exec_count = ActiveRecord::ConnectionAdapters::NullDB.execution_log.size
    @employee.save!
    ActiveRecord::ConnectionAdapters::NullDB.execution_log.size.should ==
      (exec_count + 1)
  end

  it "should have the adapter name 'NullDB'" do
    @employee.connection.adapter_name.should == "NullDB"
  end

  it "should support migrations" do
    @employee.connection.supports_migrations?.should be_true
  end

  def should_have_column(klass, col_name, col_type)
    col = klass.columns_hash[col_name.to_s]
    col.should_not be_nil
    col.type.should == col_type
  end
end
