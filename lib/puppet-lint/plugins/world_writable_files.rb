PuppetLint.new_check(:world_writable_files) do
  def check
    resource_indexes.each do |resource|
      next unless resource[:type].value == 'file'

      param_tokens = resource[:param_tokens].select { |pt| pt.value == 'mode' }

      param_tokens.each do |param_token|
        # get the file modes value
        value_token = param_token.next_code_token.next_code_token

        # we only work with octal for now - also stops file { mode => undef }
        break if value_token.value !~ /^\d+$/
        break if value_token.value =~ /\d+[^2367]$/

        notify :warning, {
          message: 'files should not be created with world writable permissions',
          line:    value_token.line,
          column:  value_token.column,
          token:   value_token,
        }
      end
    end
  end
end
