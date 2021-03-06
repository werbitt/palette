Feature: Run palette from the command line
  In order to easily generate Vim color schemes
  As a user of palette
  I should be able to point palette to a file to generate a color schem

  Scenario: Process a complete valid file
    Given a file named "valid_scheme" with:
      """
      vim_colors "valid_scheme" do
        author "Josh Clayton"
        notes  "This is a pretty simple example"
        reset  true
        background :light

        black = "000"
        white = "FFF"
        Normal     black, white
        Identifier white, black

        link :rubyDelimiter, :rubyInterpolationDelimiter, :to => :String
      end
      """
    When I run "palette valid_scheme"
    Then the output should contain:
      """
      " Vim color file
      "   This file was generated by Palette
      "   http://rubygems.org/gems/palette
      "
      " Author: Josh Clayton
      " Notes:  This is a pretty simple example

      let colors_name="valid_scheme"

      hi clear
      if version > 580
          if exists("syntax_on")
              syntax reset
          endif
      endif

      if has("gui_running")
          set background=light
      endif

      hi Normal     guifg=#000000 ctermfg=16  guibg=#FFFFFF ctermbg=231
      hi Identifier guifg=#FFFFFF ctermfg=231 guibg=#000000 ctermbg=16

      hi link rubyDelimiter              String
      hi link rubyInterpolationDelimiter String
      """

  Scenario: Process a file with color math
    Given a file named "valid_scheme" with:
      """
      vim_colors "valid_scheme" do
        Normal     darken("FFF", 40), invert("F00")
        Identifier lighten("000", 60), complement("F00")
      end
      """
    When I run "palette valid_scheme"
    Then the output should contain:
      """
      hi Normal     guifg=#999999 ctermfg=246 guibg=#00FFFF ctermbg=51
      hi Identifier guifg=#999999 ctermfg=246 guibg=#00FFFF ctermbg=51
      """

  Scenario: Process a nonexistant file
    When I run "palette missing_scheme"
    Then the output should not contain "colors_name"
    And the exit status should be 0

  Scenario: Process a file with invalid palette syntax
    Given a file named "invalid_scheme" with:
      """
      vim_colors "bad syntax" do
        totally made up junk
      end
      """
    When I run "palette invalid_scheme"
    Then the exit status should be 1
    And the output should contain "Please check the syntax of your palette file"

  Scenario: Process a file with Ruby constants
    Given a file named "valid_theme" with:
      """
      vim_colors "ruby constants" do
        String "000", "FFF"
        Float  "FFF", "000"
      end
      """
    When I run "palette valid_theme"
    Then the output should contain:
      """
      hi String guifg=#000000 ctermfg=16  guibg=#FFFFFF ctermbg=231
      hi Float  guifg=#FFFFFF ctermfg=231 guibg=#000000 ctermbg=16
      """

  Scenario: Process a file where links are self-referential
    Given a file named "valid_theme" with:
      """
      vim_colors "self-referential links" do
        link :htmlTag, :to => :Type
        link :htmlEndTag, :htmlTagName, :to => :htmlTag
      end
      """
    When I run "palette valid_theme"
    Then the output should contain:
      """
      hi link htmlTag     Type
      hi link htmlEndTag  htmlTag
      hi link htmlTagName htmlTag
      """
