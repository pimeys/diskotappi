# coding: utf-8
require_relative '../spec_helper'

class HelperClass
  include BotHelper
end

describe BotHelper do
  let(:bot) { double(:bot, nick: 'diskotappi') }

  context 'when deciding is the bot addressed' do
    let(:message) { double(:message, bot: bot, message: message_text) }

    subject { HelperClass.new.bot_addressed?(message) }

    context 'and addressing the bot with no punctuation' do
      let(:message_text) { 'diskotappi hei hei mitä kuuluu' }

      it { should be true }
    end

    context 'and addressing the bot with : punctuation mark' do
      let(:message_text) { 'diskotappi: hei hei mitä kuuluu' }

      it { should be true }
    end

    context 'and addressing the bot with , punctuation mark' do
      let(:message_text) { 'diskotappi, hei hei mitä kuuluu' }

      it { should be true }
    end

    context 'when addressing somebody else' do
      let(:message_text) { 'pimeys, hei hei mitä kuuluu' }

      it { should be false }
    end

    context 'when not addressing anybody' do
      let(:message_text) { 'kaljaa' }

      it { should be false }
    end
  end

  context 'when fetching the addressed text' do
    let(:message) { double(:message, bot: bot, message: message_text) }

    subject { HelperClass.new.addressed_text(message) }

    context 'and addressing the bot with no punctuation' do
      let(:message_text) { 'diskotappi hei hei mitä kuuluu' }

      it { should eql 'hei hei mitä kuuluu' }
    end

    context 'and addressing the bot with : punctuation mark' do
      let(:message_text) { 'diskotappi: hei hei mitä kuuluu' }

      it { should eql 'hei hei mitä kuuluu' }
    end

    context 'and addressing the bot with , punctuation mark' do
      let(:message_text) { 'diskotappi, hei hei mitä kuuluu' }

      it { should eql 'hei hei mitä kuuluu' }
    end
  end
end
