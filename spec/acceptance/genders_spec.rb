require 'spec_helper_acceptance'

describe 'genders class:' do
  context 'default parameters' do
    it 'runs successfully' do
      pp = <<-EOS
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
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('genders') do
      it { is_expected.to be_installed }
    end
  end
end
