module Validation
  module Rule
    class Email
      include Rule

      rule_id :email

      EMAIL_ADDRESS = begin
        letter         = 'a-zA-Z'
        digit          = '0-9'
        atext          = "[#{letter}#{digit}\!\#\$\%\&\'\*+\/\=\?\^\_\`\{\|\}\~\-]"
        dot_atom_text  = "#{atext}+([.]#{atext}*)+"
        dot_atom       = dot_atom_text
        no_ws_ctl      = '\x01-\x08\x11\x12\x14-\x1f\x7f'
        qtext          = "[^#{no_ws_ctl}\\x0d\\x22\\x5c]"  # Non-whitespace, non-control character except for \ and "
        text           = '[\x01-\x09\x11\x12\x14-\x7f]'
        quoted_pair    = "(\\x5c#{text})"
        qcontent       = "(?:#{qtext}|#{quoted_pair})"
        quoted_string  = "[\"]#{qcontent}+[\"]"
        atom           = "#{atext}+"
        word           = "(?:#{atom}|#{quoted_string})"
        obs_local_part = "#{word}([.]#{word})*"
        local_part     = "(?:#{dot_atom}|#{quoted_string}|#{obs_local_part})"
        dtext          = "[#{no_ws_ctl}\\x21-\\x5a\\x5e-\\x7e]"
        dcontent       = "(?:#{dtext}|#{quoted_pair})"
        domain_literal = "\\[#{dcontent}+\\]"
        obs_domain     = "#{atom}([.]#{atom})+"
        domain         = "(?:#{dot_atom}|#{domain_literal}|#{obs_domain})"
        addr_spec      = "#{local_part}\@#{domain}"
        pattern        = /\A#{addr_spec}\z/u
      end

      def validate(value, context)
        return if blank?(value)

        context.errors << :invalid unless EMAIL_ADDRESS.match(value)
      end
    end
  end
end
