require 'test_helper'

class ColumnsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @column = columns :sample_column
  end

  test "should raise an error if the specified id is not an author's" do
    assert_raises ActiveRecord::RecordNotFound do
      # no record has an id of 0
      get column_path 0
    end
  end

  test 'should get show' do
    get column_path @column.author
    assert_response :success
    assert_template 'columns/show'
  end

  test "should display the author's info" do
    get column_path @column.author
    assert_select 'h1', text: "#{@column.author.full_name}'s column"
    assert_select 'p#author-biography', text: @column.author.biography
  end

  test "should paginate the column's articles" do
    travel 1.years do  # eliminate the presence of relevant articles
      get column_path @column.author
      assert_select 'main nav.pagination', count: 1
      first_page_of_articles = @column.articles.paginate(page: 1, per_page: 10)
      assert_select '.articles-list' do
        assert_select 'li', 10
      end
      first_page_of_articles.each do |article|
        assert_select 'a.article-link[href=?]', article_path(article)
        assert_select 'h3', text: article.title
        assert_select 'p', text: article.content
        assert_select 'img[src=?]', article.thumbnail.url if article.thumbnail?
      end
    end
  end
end

