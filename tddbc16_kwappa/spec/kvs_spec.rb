# -*- coding: utf-8 -*-
require 'rspec'
require './kvs'

describe Kvs do
  before do
    @kvs = Kvs.new
  end

  describe '#put' do
    context 'put a pair of key and value' do
      subject { @kvs.put 'key1', 'value1' }
      it { should == 'value1' }
    end

    context 'put nil key' do
      specify do
        expect { @kvs.put nil, 'value' }.to raise_error KeyError
      end
    end

    context 'put nil value' do
      subject { @kvs.put 'key1', nil }
      it { should be_nil }
    end

    context 'given existing key' do
      before do
        @kvs.put 'key1', 'value1'
        @kvs.put 'key2', 'value2'
      end
      subject { @kvs.put 'key1', 'new_value1' }
      it { should == @kvs.get('key1') }
    end
  end

  describe '#get' do
    context 'put a pair of key and value' do
      before do
        @kvs.put 'key1', 'value1'
      end
      subject { @kvs.get 'key1' }
      it { should == 'value1' }
    end
  end

  describe '#dump' do
    context 'when empty' do
      subject { @kvs.dump }
      it { should == '' }
    end

    context 'after put one pair' do
      before do
        @kvs.put 'key1', 'value1'
      end
      subject { @kvs.dump }
      it { should == "key1:value1" }
    end

    context 'after put two pairs' do
      before do
        @kvs.put 'key1', 'value1'
        @kvs.put 'key2', 'value2'
      end
      subject { @kvs.dump }
      it { should == "key1:value1\nkey2:value2" }
    end
  end

  describe '#delete' do
    before do
      @kvs.put 'key1', 'value1'
    end

    context 'existing key was given' do
      subject { @kvs.delete 'key1' }
      it { should == 'value1' }
    end

    context 'nil key was given' do
      specify do
        expect { @kvs.delete nil }.to raise_error KeyError
      end
    end
  end

  describe '#merge' do
    before do
      @kvs.put 'key1', 'value1'
    end

    context 'hash is given' do
      before do
        @kvs.merge( {'key2' => 'value2', 'key3' => 'value3' } )
      end
      specify do
        {'key1' => 'value1', 'key2' => 'value2', 'key3' => 'value3' }.each do |k, v|
          @kvs.get(k).should == v
        end
      end
    end

    context 'odd count array is given' do
      specify do
        expect { @kvs.merge([1, 2, 3]) }.to raise_error ArgumentError
      end
    end

    context 'even count array is given' do
      before do
        @kvs.merge( ['key2', 'value2', 'key3', 'value3'] )
      end
      specify do
        {'key1' => 'value1', 'key2' => 'value2', 'key3' => 'value3' }.each do |k, v|
          @kvs.get(k).should == v
        end
      end
    end

    context 'odd count array is given' do
      specify do
        expect { @kvs.merge([1, 2, 3]) }.to raise_error ArgumentError
      end
    end

    context 'none hash is given' do
      specify do
        expect { @kvs.merge("hogepiyo") }.to raise_error ArgumentError
      end
    end
  end
end
