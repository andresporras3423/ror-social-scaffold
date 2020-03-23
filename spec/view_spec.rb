require 'spec_helper'

RSpec.describe 'index page', type: :feature do
  before(:all) do
    @user1 = User.create(name: 'user1', email: 'user1@u1.com', password: '123456', password_confirmation: '123456')
    @user1.save

    @user2 = User.create(name: 'user2', email: 'user2@u2.com', password: '123456', password_confirmation: '123456')
    @user2.save

    @user3 = User.create(name: 'user3', email: 'user3@u3.com', password: '123456', password_confirmation: '123456')
    @user3.save
  end


  scenario 'index page' do
    visit '/'
    expect(page).to have_content('Sign in')
  end
  scenario 'visit sign up page' do
    visit '/users/sign_up'
    expect(page).to have_content('Sign up')
  end

  scenario 'test signup event' do
    visit '/users/sign_up'
    fill_in 'Name', with: 'fernando'
    fill_in 'Email', with: 'f@f.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_button 'Sign up'
    page.should have_content('Welcome! You have signed up successfully.')
  end

  scenario 'test login event' do
    visit '/users/sign_in'
    fill_in 'Email', with: 'user1@u1.com'
    fill_in 'Password', with: '123456'
    click_button 'Log in'
    page.should have_content('Signed in successfully.')
  end

  scenario 'test post event' do
    visit '/users/sign_in'
    fill_in 'Email', with: 'user1@u1.com'
    fill_in 'Password', with: '123456'
    click_button 'Log in'
    fill_in 'post_content', with: 'my first post'
    click_button 'Save'
    page.should have_content('my first post')
  end

  scenario 'test post event' do
    visit '/users/sign_in'
    fill_in 'Email', with: 'user1@u1.com'
    fill_in 'Password', with: '123456'
    click_button 'Log in'
    fill_in 'post_content', with: 'my first post'
    click_button 'Save'
    fill_in 'comment_content', with: 'my first comment'
    click_button 'Comment'
    page.should have_content('my first comment')
  end

  scenario 'test like event' do
    visit '/users/sign_in'
    fill_in 'Email', with: 'user1@u1.com'
    fill_in 'Password', with: '123456'
    click_button 'Log in'
    fill_in 'post_content', with: 'my first post'
    click_button 'Save'
    find("a", :text => "Like!").click 
    page.should have_content('likes: 1')
  end

  scenario 'test show user' do
    visit '/users/sign_in'
    fill_in 'Email', with: 'user1@u1.com'
    fill_in 'Password', with: '123456'
    click_button 'Log in'
    find("a", :text => "All users").click 
    page.should have_content('Name: user2')
  end

  scenario 'test frienship' do
    visit '/users/sign_in'
    fill_in 'Email', with: 'user1@u1.com'
    fill_in 'Password', with: '123456'
    click_button 'Log in'
    find("a", :text => "All users").click 
    click_button 'invite2'
    f1 = Friendship.find_by(user_id: 1, friend_id: 2, confirmed: nil)
    expect(f1.valid?).to eq(true)
  end

  scenario 'test sign out' do
    visit '/users/sign_in'
    fill_in 'Email', with: 'user1@u1.com'
    fill_in 'Password', with: '123456'
    click_button 'Log in'
    find("a", :text => "Sign out").click 
    page.should have_content('You need to sign in or sign up before continuing.')
  end

end