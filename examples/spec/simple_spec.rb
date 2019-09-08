#!/usr/bin/env rspec

# This is untested hypothetical example code only!
#
# It is pending implementation of the InSpec AWS types 
# aws_guardduty_detectors, aws_guardduty_ipset,
# aws_guardduty_threatintelset etc.
#
# These would be based on existing types in
# https://github.com/inspec/inspec-aws/tree/master/docs/resources
# and would need to be contributed to that project.

def terraform(action, dir)
  Dir.chdir(dir)
  exit_status = system("terraform #{action} -auto-approve")
  Dir.chdir("..")
  return exit_status
end

describe "terraform apply" do
  it "should return exit status 0" do
    exit_status = terraform("apply", "./master_simple")
    expect(exit_status).to eq 0
  end
end

detector_id = aws_guardduty_detectors[0]

describe "detector_id" do
  it "should be 32 characters in length" do
    expect(detector_id.length).to eq 32
  end
end

describe aws_guardduty_ipset(detector_id: detector_id) do
  its(:status)   { should eq "ACTIVE" }
  its(:format)   { should eq "TXT" }
  its(:name)     { should eq "IPSet" }
  its(:location) { should match /ipset.txt/ }
end

describe aws_guardduty_threatintelset(detector_id: detector_id) do
  its(:status)   { should eq "ACTIVE" }
  its(:format)   { should eq "TXT" }
  its(:name)     { should eq "IPSet" }
  its(:location) { should match /threatintelset.txt/ }
end

describe "terraform destroy" do
  it "should return exit status 0" do
    exit_status = terraform("destroy", "./master_simple")
    expect(exit_status).to eq 0
  end
end
