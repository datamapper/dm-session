require 'spec_helper'

describe Session::Session,'#delete_now' do
  let(:mapper) { DummyMapper.new }
  let(:mapper_root)   { DummyMapperRoot.new(mapper) }
  let(:object) { described_class.new(mapper_root) }

  let(:domain_object) { DomainObject.new }

  subject { object.delete_now(domain_object) }

  context 'when session is committed' do
    let!(:key_before) { mapper.dump_key(domain_object) }

    before do
      object.insert_now(domain_object)
      subject
    end

    it 'should commit session' do
      object.committed?.should be_true
    end

    it 'should delete object' do
      mapper.deletes.should == [[domain_object,key_before]]
    end
  end

  context 'when session is uncommitted' do
    before do
      object.insert(Object.new) 
    end

    it 'should raise error' do
      expect { subject }.to raise_error
    end
  end
end