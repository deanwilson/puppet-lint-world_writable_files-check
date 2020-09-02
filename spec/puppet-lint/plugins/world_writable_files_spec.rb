require 'spec_helper'

describe 'world_writable_files' do
  context 'when the manifest has no file resources' do
    let(:code) do
      <<-TEST_CLASS
        class no_file_resource {
          host { 'syslog':
            ip => '10.10.10.10',
          }
        }
      TEST_CLASS
    end

    it 'does not detect any problems' do
      expect(problems).to have(0).problems
    end
  end

  context 'when file resource has a mode of 640' do
    let(:code) do
      <<-TEST_CLASS
        class locked_down_file {
          file { '/tmp/locked_down':
            ensure => 'file',
            mode   => '0640',
          }
        }
      TEST_CLASS
    end

    it 'does not detect any problems' do
      expect(problems).to have(0).problems
    end
  end

  context 'when file has a mode of undef' do
    let(:code) do
      <<-TEST_CLASS
        class undef_file_mode {
          file { '/tmp/undef_file_mode':
            ensure => 'file',
            mode   => undef,
          }
        }
      TEST_CLASS
    end

    it 'does not detect any problems' do
      expect(problems).to have(0).problems
    end
  end

  context 'when file has a world writable octal mode of 666' do
    let(:msg) { 'files should not be created with world writable permissions' }
    let(:code) do
      <<-TEST_CLASS
        class locked_down_file {
          file { '/tmp/open_octal':
            ensure => 'file',
            mode   => '0666',
          }
        }
      TEST_CLASS
    end

    it 'detects a problem' do
      expect(problems).to have(1).problem
    end

    it 'creates a warning' do
      expect(problems).to contain_warning(msg).on_line(4).in_column(23)
    end
  end
end
