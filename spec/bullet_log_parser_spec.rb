# frozen_string_literal: true

RSpec.describe BulletLogParser do
  it 'has a version number' do
    expect(BulletLogParser::VERSION).not_to be nil
  end

  describe 'singleton method' do
    describe '.uniq_log' do
      file_pattern = 'spec/fixtures/files/real/**/bullet.*.log'
      Dir[Pathname.pwd.join(file_pattern)].sort.each do |filepath|
        it "read #{File.basename(filepath)}" do
          counts = 0
          File.open(filepath, 'r') do |io|
            memo = described_class.uniq_log(io) do |_ast|
              counts += 1
            end
            expect(memo.keys.size).to be > 1
          end
          expect(counts).to be > 1
        end
      end

      it 'read 2 type logs' do
        filepath = Pathname.pwd.join('spec/fixtures/files/bullet_2type.log')
        counts = 0
        File.open(filepath, 'r') do |io|
          memo = described_class.uniq_log(io) do |_ast|
            counts += 1
          end
          expect(memo.keys.size).to eq 2
          expect(memo['Sample1'].size).to eq 1
          expect(memo['Sample2'].size).to eq 1
        end
        expect(counts).to eq 2
      end

      it 'read same type logs' do
        filepath = Pathname.pwd.join('spec/fixtures/files/bullet_same.log')
        counts = 0
        File.open(filepath, 'r') do |io|
          memo = described_class.uniq_log(io) do |_ast|
            counts += 1
          end
          expect(memo.keys.size).to eq 1
          expect(memo['Sample1'].size).to eq 1
        end
        expect(counts).to eq 1
      end
    end
  end
end
