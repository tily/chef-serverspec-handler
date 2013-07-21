require 'spec_helper'

describe 'chef_serverspec_handler_test::default' do
  context file('/var/tmp/file.txt') do
    it {
      should be_file
      should contain <<-EOF
      chef serverspec handler file resource test

      EOF
      should be_mode 777
      should be_owned_by 'root'
    }
  end

  context file('/var/tmp/cookbook_file.txt') do
    it {
      should be_file
      should be_mode 777
      should be_owned_by 'root'
    }
  end

  context file('/var/tmp/remote_file.txt') do
    it {
      should be_file
      should be_mode 777
      should be_owned_by 'root'
    }
  end

  context file('/var/tmp/directory') do
    it {
      should be_directory
      should be_mode 777
      should be_owned_by 'root'
    }
  end

  context file('/var/tmp/remote_directory') do
    it {
      should be_directory
      should be_mode 777
      should be_owned_by 'root'
    }
  end

  context file('/var/tmp/template.txt') do
    it {
      should be_file
      should be_mode 777
      should be_owned_by 'root'
      should contain 'val1'
      should contain 'val2'
      should contain 'val3'
    }
  end

  context file('/var/tmp/link') do
    it {
      should be_linked_to '/var/tmp/file.txt'
      should be_owned_by 'root'
    }
  end

  context user('tily') do
    it {
      should exist
      should have_uid 500
      should have_home_directory '/home/tily'
      should have_login_shell '/bin/bash'
    }
  end

  context group('tily') do
    it { should exist }
    it { should have_gid 500 }
  end

  context service('httpd') do
    it { should be_running }
  end

  context service('httpd') do
    it { should be_enabled }
  end

  context cron do
    it { should have_entry('0 20 * 10 1-5 echo hello > /var/tmp/cron.txt').with_user('root') }
  end

end

