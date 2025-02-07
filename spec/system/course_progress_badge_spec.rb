require 'rails_helper'

RSpec.describe 'Course Progress Badge' do
  let!(:path) { create(:path, default_path: true) }
  let!(:course) { create(:course, path:) }
  let!(:first_lesson) { create(:lesson, course:) }
  let!(:second_lesson) { create(:lesson, course:) }

  before do
    sign_in(create(:user))
  end

  context 'when course has not been started' do
    it 'does not show progress percentage' do
      visit path_course_path(path, course)

      within find(:test_id, 'default-badge') do
        expect(page).not_to have_content('0%')
      end
    end
  end

  context 'when course has some progress' do
    it 'shows percentage of completion' do
      visit lesson_path(first_lesson)

      find(:test_id, 'complete-button').click
      visit path_course_path(path, course)

      within find(:test_id, 'progress-badge') do
        expect(page).to have_content('50%')
      end
    end
  end

  context 'when course is completed' do
    it 'shows 100% completion' do
      visit lesson_path(first_lesson)
      find(:test_id, 'complete-button').click

      visit lesson_path(second_lesson)
      find(:test_id, 'complete-button').click

      visit path_course_path(path, course)

      within find(:test_id, 'progress-badge') do
        expect(page).to have_content('100%')
      end
    end
  end
end
