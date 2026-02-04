# frozen_string_literal: true

require 'spec_helper'

describe 'genders' do
  on_supported_os.each do |os, os_facts|
    context "when #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      if os_facts[:os]['family'] == 'RedHat'
        it { is_expected.to contain_class('epel') }
        it { is_expected.to contain_yumrepo('epel').that_comes_before('Package[genders]') }
      else
        it { is_expected.not_to contain_class('epel') }
      end

      it do
        is_expected.to contain_package('genders').with(ensure: 'installed', name: 'genders')
      end

      it do
        is_expected.to contain_concat('/etc/genders').with(
          ensure: 'present',
          path: '/etc/genders',
          owner: 'root',
          group: 'root',
          mode: '0644',
          validate_cmd: 'nodeattr -f % -k',
          require: 'Package[genders]',
        )
      end

      it do
        is_expected.to contain_concat__fragment('/etc/genders.header')
      end
    end
  end
end
