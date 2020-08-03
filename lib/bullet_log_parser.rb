# frozen_string_literal: true

require 'bullet_log_parser/version'
require 'bullet_log_parser/parser'
require 'set'

module BulletLogParser # :nodoc:
  def self.generate_bare_ast(ast)
    bare_ast = ast.reject { |k, _| %i[detectedAt request].include?(k) }
    bare_ast[:stack] = bare_ast[:stack].map { |stack| stack.reject { |k, _| k == :message } }
    bare_ast
  end

  def self.uniq_log(io)
    memo = Hash.new { |h, k| h[k] = Set.new }
    parse(io) do |ast|
      bare_ast = generate_bare_ast(ast)
      detection = memo[bare_ast[:detection]]
      next if detection.include?(bare_ast)

      detection << bare_ast
      yield ast
    end
    memo
  end

  def self.parse(io, &block)
    parser = Parser.new
    loop do
      line = io.gets
      unless line
        parse_line(parser, '', &block)
        break
      end

      parser = Parser.new if parse_line(parser, line.chomp, &block)
    end
  end

  def self.parse_line(parser, line)
    parser.puts(line)
    return false unless parser.completed?

    yield parser.ast
    true
  end
end
