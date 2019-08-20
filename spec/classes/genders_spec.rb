require 'spec_helper'

describe 'genders' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:package_require) do
        if facts[:os]['family'] == 'RedHat'
          'Yumrepo[epel]'
        else
          nil
        end
      end

      it { is_expected.to compile }

      if os_facts[:os]['family'] == 'RedHat'
        it { is_expected.to contain_class('epel') }
      else
        it { is_expected.not_to contain_class('epel') }
      end

      it do
        is_expected.to contain_package('genders').with(ensure: 'installed', name: 'genders', require: package_require)
      end

      it do
        is_expected.to contain_exec('verify-genders').with_command('nodeattr -f /etc/genders.puppet -k')
      end

      it do
        is_expected.to contain_file('/etc/genders').with_path('/etc/genders')
      end

      it do
        is_expected.to contain_concat('/etc/genders').with(ensure: 'present',
                                                           path: '/etc/genders.puppet',
                                                           owner: 'root',
                                                           group: 'root',
                                                           mode: '0644',
                                                           require: 'Package[genders]',
                                                           notify: 'Exec[verify-genders]')
      end

      it do
        is_expected.to contain_concat__fragment('/etc/genders.header')
      end

      context 'when verify_config => false' do
        let(:params) { { verify_config: false } }

        it { is_expected.not_to contain_exec('verify-genders') }
        it { is_expected.not_to contain_file('/etc/genders') }
        it do
          is_expected.to contain_concat('/etc/genders').with(ensure: 'present',
                                                             path: '/etc/genders',
                                                             owner: 'root',
                                                             group: 'root',
                                                             mode: '0644',
                                                             require: 'Package[genders]',
                                                             notify: nil)
        end
      end
    end
  end
end
