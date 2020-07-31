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
    end
  end
end
