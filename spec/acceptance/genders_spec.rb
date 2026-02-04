# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'genders class:' do
  context 'with default parameters' do
    it 'runs successfully' do
      pp = <<-PP
      class { 'genders': }
      genders::node { 'compute01':
        attrs => ['compute','rack01'],
      }
      genders::node { 'compute02':
        attrs => {'role' => 'compute','rack' => 'rack01'},
      }
      genders::node { 'compute':
        node  => ['compute03','compute04'],
        attrs => ['compute','rack01'],
      }
      PP

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('genders') do
      it { is_expected.to be_installed }
    end

    describe command('nodeattr -l compute02') do
      its(:stdout) { is_expected.to include('rack=rack01') }
    end

    describe command('nodeattr -n rack01') do
      its(:stdout) { is_expected.to include('compute01') }
      its(:stdout) { is_expected.to include('compute03') }
      its(:stdout) { is_expected.to include('compute04') }
      its(:stdout) { is_expected.not_to include('compute02') }
    end
  end
end
