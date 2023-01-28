require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.where(activated: true).paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'Delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@admin)
      assert_response :see_other
      assert_redirected_to users_url
    end
  end

  test "should display only activated users" do
    # Deactivate the first user on the page.
    # Making an inactive fixture user isn't sufficient because Rails can't
    # guarantee it would appear on the first page.
    log_in_as(@admin)
    User.paginate(page: 1).first.toggle!(:activated)
    # Re-get /users to confirm the deactivated user doesn't appear.
    get users_path
    # Ensure that all the displayed users are activated.
    assigns(:users).each do |user|
      assert user.activated?
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
