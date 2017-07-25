# frozen_string_literal: true

$LOAD_PATH << File.join(File.dirname(__FILE__), '/lib')

require File.expand_path('google_drive_proxy', File.dirname(__FILE__))
run GoogleDriveProxy
