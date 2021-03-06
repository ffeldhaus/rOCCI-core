module Occi
  module Core
    describe Entity do

      it "initializes itself successfully" do
        entity = Occi::Core::Entity.new
        entity.should be_kind_of Occi::Core::Entity
      end

      it "initializes a subclass successfully using a type identifier" do
        type_identifier = 'http://example.com/testnamespace#test'
        entity = Occi::Core::Entity.new type_identifier
        entity.should be_kind_of 'Com::Example::Testnamespace::Test'.constantize
        entity.kind.type_identifier.should == type_identifier
        entity.kind.related.first.should == Occi::Core::Entity.kind
      end

      it "initializes a subclass successfully using an OCCI Kind" do
        kind = Occi::Core::Resource.kind
        entity = Occi::Core::Entity.new kind
        entity.should be_kind_of Occi::Core::Resource
        entity.kind.type_identifier.should == Occi::Core::Resource.type_identifier
        entity.kind.related.first.should == Occi::Core::Entity.kind
      end

      it "converts mixin type identifiers to objects if a mixin is added to the entities mixins" do
        mixin = 'http://example.com/mynamespace#mymixin'
        entity = Occi::Core::Entity.new
        entity.mixins << mixin
        entity.mixins.first.to_s.should == mixin
      end

      # TODO: check adding of model
      it "checks a valid attribute value against their definition in its kind and associated mixins" do
        entity = Occi::Core::Entity.new
        expect { entity.check }.to raise_error
        entity.model = Occi::Model.new
        entity.title = 'test'
        uuid = UUIDTools::UUID.random_create.to_s
        entity.id = uuid
        expect { entity.check }.to_not raise_error
      end

    end
  end
end
