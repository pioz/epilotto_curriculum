require 'yaml'
require 'term/ansicolor'

module EpilottoCurriculum
  include Term::ANSIColor

  def build_from_yaml(yaml_file, width: 80, left_column_max_width_percent: 30)
    cv = YAML.load_file(yaml_file)
    name = cv.delete('name')
    left_column_max_width = (width * (left_column_max_width_percent/100.0)).round
    max_paragraph_width = cv.values.map(&:keys).flatten.max{|x,y| x.size <=> y.size}.size
    lc_w = (max_paragraph_width <= left_column_max_width ? max_paragraph_width : left_column_max_width) + 1
    rc_w = width - 3 - lc_w

    s = [draw_title(name, width)]
    cv.each do |section, data|
      if section != :name
        s << draw_section(section, width) # lc_w - 1
        data.each do |left, right|
          l_lines = rpad(left, lc_w).split("\n")
          r_lines = lpad(right, rc_w).split("\n")
          i = 0
          while l_lines[i] || r_lines[i] do
            l_line = l_lines[i]
            l_line = ' ' * lc_w if !l_line || l_line =~ /\s*sep\d*$/
            s << "#{l_line} #{cyan}|#{reset} #{r_lines[i]}"
            i += 1
          end
        end
      end
    end
    s << ''
    return s.join("\n")
  end

  private

  def lpad(s, width)
    return '' unless s
    lines = s.to_s.split("\n")
    output = []
    lines.each do |line|
      pad = line[0] == '*' ? 2 : 0
      words = line.split
      r = words.first
      if words.any?
        w = r.gsub(/<\/?b>/, '').size
        words[1..-1].each do |word|
          size = word.gsub(/<\/?b>/, '').size
          if w + size + 1 <= width
            r += ' ' + word
            w += size + 1
          else
            n = "\n"
            if r.scan(/<b>/).size != r.scan(/<\/b>/).size
              n = "</b>\n<b>"
            end
            r += n + ' ' * pad + word
            w = size
          end
        end
      end
      output << r.to_s.gsub('<b>', bold).gsub('</b>', reset)
    end
    return output.join("\n")
  end

  def rpad(s, width)
    s = lpad(s, width)
    r = []
    s.split("\n").each do |line|
      r << line.rjust(width)
    end
    return r.join("\n")
  end

  def draw_title(name, width)
    title = "#{name.upcase}'s curriculum vitæ"
    s = "#{title} (last update 1 March 2017)".center(width)
    s.gsub!(title, bold(red(title)))
    return "\n#{s}\n"
  end

  def draw_section(s, width)
    lw = width - s.size - 4
    lw = lw < 0 ? 0 : lw
    return bold(yellow("#{'─'*2} #{s} #{'─'*lw}"))
  end

end
