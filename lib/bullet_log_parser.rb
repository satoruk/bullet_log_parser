# frozen_string_literal: true

require 'bullet_log_parser/version'
require 'bullet_log_parser/parser'

module BulletLogParser # :nodoc:
  def self.generate_bare_ast(ast)
    bare_ast = ast.reject { |k, _| %i[detectedAt request].include?(k) }
    bare_ast[:stack] = bare_ast[:stack].map { |stack| stack.reject { |k, _| k == :message } }
    bare_ast
  end

  def self.uniq_log(io)
    memo = Hash.new { |h, k| h[k] = [] }
    parse(io) do |ast|
      bare_ast = generate_bare_ast(ast)
      detection = memo[bare_ast[:detection]]
      next if detection.include?(bare_ast)

      detection << bare_ast
      yield ast
    end
    memo
  end

  def self.parse(io)
    parser = Parser.new
    loop do
      str = io.gets
      break unless str

      parser.puts(str.chomp)
      next unless parser.terminated?

      yield parser.ast unless parser.failed?

      parser = Parser.new
    end
  end
end