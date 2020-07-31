# frozen_string_literal: true

module BulletLogParser # :nodoc:
  # bullert log persing class
  class Parser
    REGEX_CALL_STACK = /\A  (.+):(\d+):(.+)\z/.freeze
    REGEX_DETAIL = /\A  (.+)\z/.freeze
    REGEX_LINE1 = /\A(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})\[(\w+)\] user: (.*)\z/.freeze

    def initialize
      @parse_method = :parse_line1
      @ast = {}
      @terminated = false
      @failed = false
    end

    attr_reader :ast

    def failed
      @failed = true
    end

    def failed?
      @failed
    end

    def terminated
      @terminated = true
    end

    def terminated?
      @terminated || @failed
    end

    def puts(str)
      perse_proc = method(@parse_method).curry
      perse_proc.call(str)
    end

    private

    def parse_line1(str)
      matched = REGEX_LINE1.match(str)
      return failed unless matched

      @parse_method = :parse_line2
      @ast.update({
                    detectedAt: matched[1],
                    level: matched[2],
                    user: matched[3]
                  })
    end

    def parse_line2(str)
      @parse_method = :parse_line_detector
      return if str.empty?

      @ast.update({ request: str })
    end

    def parse_line_detector(str)
      @parse_method = :parse_line_detector_detail
      return failed if str.empty?

      @ast.update({
                    detection: str,
                    details: [],
                    stack: []
                  })
    end

    def parse_line_detector_detail(str)
      if str == 'Call stack'
        @parse_method = :parse_line_call_stack_detail
        return
      end

      return terminated if str.empty?

      matched = REGEX_DETAIL.match(str)
      return failed unless matched

      @ast[:details] << matched[1]
    end

    def parse_line_call_stack_detail(str)
      return terminated if str.empty?

      matched = REGEX_CALL_STACK.match(str)
      return failed unless matched

      @ast[:stack] << {
        filename: matched[1],
        lineno: matched[2].to_i,
        message: matched[3]
      }
    end
  end
end
