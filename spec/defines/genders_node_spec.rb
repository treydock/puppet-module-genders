# frozen_string_literal: true

require 'spec_helper'

describe 'genders::node' do
  on_supported_os.each do |os, os_facts|
    context "when #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'compute01' }
      let(:params) do
        {
          attrs: ['compute', 'rack01'],
        }
      end

      it { is_expected.to compile }

      it do
        is_expected.to contain_concat__fragment('/etc/genders.compute01').with(
          target: '/etc/genders',
          content: %r{^compute01 compute,rack01$},
          order: '50',
        )
      end

      context 'when attrs is hash' do
        let(:params) do
          {
            attrs: { 'role' => 'compute', 'rack' => 'rack01' },
          }
        end

        it { is_expected.to contain_concat__fragment('/etc/genders.compute01').with_content(%r{^compute01 role=compute,rack=rack01$}) }
      end

      context 'when node is array' do
        let(:title) { 'compute' }
        let(:params) do
          {
            node: ['compute01', 'compute02'],
            attrs: ['compute', 'rack01'],
          }
        end

        it { is_expected.to contain_concat__fragment('/etc/genders.compute').with_content(%r{^compute01,compute02 compute,rack01$}) }
      end
    end
  end
end
