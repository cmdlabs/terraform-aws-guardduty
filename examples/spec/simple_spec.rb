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

Dir.chdir("./master_simple")

describe command("terraform apply -auto-approve") do
  its(:exit_status) { should eq 0 }
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

describe command("terraform destroy -auto-approve") do
  its(:exit_status) { should eq 0 }
end
