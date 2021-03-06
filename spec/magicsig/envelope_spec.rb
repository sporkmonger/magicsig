# Copyright (C) 2010 Google Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

require 'spec_helper'

require 'magicsig/envelope'
require 'magicsig/signature'

shared_examples_for 'normal magic signature envelopes' do
  it 'should parse the data correctly' do
    @envelope.data.should == 'Tm90IHJlYWxseSBBdG9t'
  end

  it 'should never have whitespace in the data' do
    @envelope.data.should_not =~ /\s/
  end

  it 'should parse the payload correctly' do
    @envelope.payload.should == 'Not really Atom'
  end

  it 'should parse the data type correctly' do
    @envelope.data_type.should == 'application/atom+xml'
  end

  it 'should parse the encoding correctly' do
    @envelope.encoding.should == 'base64url'
  end

  it 'should parse the algorithm correctly' do
    @envelope.algorithm.should == 'RSA-SHA256'
  end

  it 'should parse at least one signature' do
    @envelope.signatures.should_not be_empty
    @envelope.signatures.first.should be_kind_of(MagicSig::Signature)
  end

  it 'should generate the message string correctly' do
    @envelope.message_string.should ==
      'Tm90IHJlYWxseSBBdG9t.YXBwbGljYXRpb24vYXRvbSt4bWw.' +
      'YmFzZTY0dXJs.UlNBLVNIQTI1Ng'
  end
end

describe MagicSig::Envelope, 'created piecewise' do
  before do
    @envelope = MagicSig::Envelope.new
    @envelope.data = 'Tm90IHJlYWxseSBBdG9t'
    @envelope.data_type = 'application/atom+xml'
    @envelope.encoding = 'base64url'
    @envelope.algorithm = 'RSA-SHA256'
    signature = MagicSig::Signature.new
    signature.value = (
      'EvGSD2vi8qYcveHnb-rrlok07qnCXjn8YSeCDDXlbh' +
      'ILSabgvNsPpbe76up8w63i2fWHvLKJzeGLKfyHg8ZomQ'
    )
    signature.key_id = '4k8ikoyC2Xh+8BiIeQ+ob7Hcd2J7/Vj3uM61dy9iRMI='
    @envelope.signatures << signature
  end

  it_should_behave_like 'normal magic signature envelopes'
end

describe MagicSig::Envelope, 'created in non-canonical form' do
  before do
    @envelope = MagicSig::Envelope.new
    @envelope.data = "\t\tTm9  \t0IHJl\n  YWxseSBBdG9t\n\n\n    "
    @envelope.data_type = 'application/atom+xml'
    @envelope.encoding = 'base64url'
    @envelope.algorithm = 'RSA-SHA256'
    signature = MagicSig::Signature.new
    signature.value = (
      'EvGSD2vi8qYcveHnb-rrlok07qnCXjn8YSeCDDXlbh' +
      'ILSabgvNsPpbe76up8w63i2fWHvLKJzeGLKfyHg8ZomQ'
    )
    signature.key_id = '4k8ikoyC2Xh+8BiIeQ+ob7Hcd2J7/Vj3uM61dy9iRMI='
    @envelope.signatures << signature
  end

  it_should_behave_like 'normal magic signature envelopes'
end

describe MagicSig::Envelope, 'with a JSON serialization' do
  before do
    @envelope = MagicSig::Envelope.parse_json(<<-JSON.strip)
      {
        "data": "Tm90IHJlYWxseSBBdG9t",
        "data_type": "application/atom+xml",
        "encoding": "base64url",
        "alg": "RSA-SHA256",
        "sigs": [{
          "value": "EvGSD2vi8qYcveHnb-rrlok07qnCXjn8YSeCDDXlbhILSabgvNsPpbe76up8w63i2fWHvLKJzeGLKfyHg8ZomQ",
          "key_id": "4k8ikoyC2Xh+8BiIeQ+ob7Hcd2J7/Vj3uM61dy9iRMI="
        }]
      }
    JSON
  end

  it_should_behave_like 'normal magic signature envelopes'
end

describe MagicSig::Envelope, 'with a pre-parsed JSON hash' do
  before do
    @envelope = MagicSig::Envelope.parse_json({
      'data' => 'Tm90IHJlYWxseSBBdG9t',
      'data_type' => 'application/atom+xml',
      'encoding' => 'base64url',
      'alg' => 'RSA-SHA256',
      'sigs' => [{
        'value' => (
          'EvGSD2vi8qYcveHnb-rrlok07qnCXjn8YSeCDDXlbh' +
          'ILSabgvNsPpbe76up8w63i2fWHvLKJzeGLKfyHg8ZomQ'
        ),
        'key_id' => '4k8ikoyC2Xh+8BiIeQ+ob7Hcd2J7/Vj3uM61dy9iRMI='
      }]
    })
  end

  it_should_behave_like 'normal magic signature envelopes'
end
