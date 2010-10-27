module Palette
  class ColorScheme
    attr_reader :name

    def initialize(color_name)
      @name = color_name
    end

    def author(author_name)
      @author_name = author_name
    end

    def notes(notes)
      @notes = notes
    end

    def reset(reset)
      @reset = !!reset
    end

    def background(shade)
      return unless %w(light dark).include?(shade.to_s)
      @background = shade.to_s
    end

    def method_missing(name, *args)
      @rules ||= []
      @rules << Palette::Rule.new(name.to_s, *args)
    end

    def String(*args)
      @rules ||= []
      @rules << Palette::Rule.new("String", *args)
    end

    def to_s
      output = []
      output << header
      output << color_scheme_name
      output << generate_reset
      output << generate_background
      output << @rules
      output << @links
      output.compact.join("\n")
    end

    def link(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}

      @links ||= []
      args.each do |arg|
        @links << Link.new(arg, options[:to])
      end
    end

    def header
      %{
" Vim color file
"   This file was generated by Palette
"   http://rubygems.org/gems/palette
"
" Author: #{@author_name}
#{%{" #{@notes}} if @notes}
      }.strip
    end

    def generate_reset
      return unless @reset
      %{
hi clear
if version > 580
    if exists("syntax_on")
        syntax reset
    endif
endif
      }.strip
    end

    def generate_background
      return unless @background
      %{
if has("gui_running")
    set background=#{@background}
endif
      }.strip
    end

    def color_scheme_name
      %{let colors_name="#{@name}"}
    end

    def self.run(name, block)
      instance = new(name)
      instance.instance_eval(&block)
      instance.to_s
    end
  end
end
