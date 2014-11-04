# encoding: UTF-8

Dado(/^que estou na página inicial$/) do
  visit root_path
end

Quando(/^clico no menu "(.*?)"$/) do |link|
  click_link link
end

Então(/^eu vejo na tela "(.*?)"$/) do |texto|
  expect(page).to have_content(texto)
end
