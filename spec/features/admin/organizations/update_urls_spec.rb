require 'rails_helper'

feature 'Update websites' do
  def set_up_organization
    @org = create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  scenario 'when no websites exist' do
    set_up_organization
    expect(page).to have_no_xpath("//input[@name='organization[urls][]']")
  end

  scenario 'by adding 2 new websites', :js do
    skip "Broken"
    set_up_organization
    add_two_urls
    expect(find_field('organization_urls_0').value).to eq 'http://ruby.com'
    delete_all_urls
    expect(page).to have_no_xpath("//input[@name='organization[urls][]']")
  end

  scenario 'with 2 urls but one is empty', :js do
    skip "Broken"
    set_up_organization
    @org.update!(urls: ['http://ruby.org'])
    visit '/admin/organizations/parent-agency'
    click_link 'Add a website'
    click_button 'Save changes'
    total_urls = all(:xpath, "//input[@type='url']")
    expect(total_urls.length).to eq 1
  end

  scenario 'with invalid website' do
    skip "Broken"
    set_up_organization
    @org.update!(urls: ['http://ruby.org'])
    visit '/admin/organizations/parent-agency'
    fill_in 'organization_urls_0', with: 'www.monfresh.com'
    click_button 'Save changes'
    expect(page).to have_content 'www.monfresh.com is not a valid URL'
  end

  scenario 'with valid website' do
    skip "Broken"
    set_up_organization
    @org.update!(urls: ['http://ruby.org'])
    visit '/admin/organizations/parent-agency'
    fill_in 'organization_urls_0', with: 'http://codeforamerica.org'
    click_button 'Save changes'
    expect(find_field('organization_urls_0').value).
      to eq 'http://codeforamerica.org'
  end
end
