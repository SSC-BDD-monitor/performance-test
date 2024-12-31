require 'test_helper'

class ACLHelperMethodTest < ActionController::TestCase
  setup do
    assert @user = User.create
  end

  test "foo owner allowed" do
    assert @user.has_role! :owner, Foo.first_or_create

    assert get :allow, params: { user_id: @user.id }
    assert_select 'div', 'OK'
  end

  test "another user denied" do
    assert @another = User.create
    assert @another.has_role! :owner, Foo.first_or_create

    assert @user.has_role! :owner

    assert get :allow, params: { user_id: @user.id }
    assert_select 'div', 'AccessDenied'
  end

  test "anon denied" do
    assert get :allow
    assert_select 'div', 'AccessDenied'
  end
end
