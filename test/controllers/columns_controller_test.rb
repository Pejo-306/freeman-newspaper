require 'test_helper'

class ColumnsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @column = columns :sample_column
  end

  test 'should get show' do
    get column_path(@column.author.full_name)
    assert_response :success
    assert_template 'columns/show'
  end

  test "should display the author's info" do
    get column_path(@column.author.full_name)
    assert_select 'h1', text: "#{@column.author.full_name}'s column"
    assert_select 'p#author-biography', text: @column.author.biography
  end

  test "should display the column's articles" do
    get column_path(@column.author.full_name)
    assert_select 'ul#articles-list' do
      assert_select 'li', count: @column.articles.count
      @column.articles.each do |article|
        assert_select 'a.article-link[href=?]', article_path(article)
        assert_select 'h3', text: article.title
        assert_select 'p.column-article-content', text: article.content
      end
    end
  end
end

