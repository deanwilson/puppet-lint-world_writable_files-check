require 'spec_helper'

describe 'world_writable_files' do
  context 'file with a mode of 640' do
    let(:code) do
      <<-EOS
        class locked_down_file {
          file { '/tmp/locked_down':
            ensure => 'file',
            mode   => '0640',
          }
        }
      EOS
    end

    it 'should not detect any problems' do
      expect(problems).to have(0).problems
    end
  end

  context 'file with a mode of undef' do
    let(:code) do
      <<-EOS
        class undef_file_mode {
          file { '/tmp/undef_file_mode':
            ensure => 'file',
            mode   => undef,
          }
        }
      EOS
    end

    it 'should not detect any problems' do
      expect(problems).to have(0).problems
    end
  end

  context 'file with a world writable octal mode of 666' do
    let(:msg) { 'files should not be created with world writable permissions' }
    let(:code) do
      <<-EOS
        class locked_down_file {
          file { '/tmp/open_octal':
            ensure => 'file',
            mode   => '0666',
          }
        }
      EOS
    end

    it 'should detect a problem' do
      expect(problems).to have(1).problem
    end

    it 'should create a warning' do
      expect(problems).to contain_warning(msg).on_line(4).in_column(23)
    end
  end


end
