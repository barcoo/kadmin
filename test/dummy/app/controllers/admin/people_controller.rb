# frozen_string_literal: true

module Admin
  class PeopleController < Admin::ApplicationController
    include Kadmin::Concerns::Resources
    include Kadmin::ChartsHelper

    # Own navigation section
    self.navbar_section = self

    # GET /admin/people
    def index
      @finder = resources_finder(
        Person.eager_load(:groups, :owned_groups).order(created_at: :desc),
        [{
          name: :name,
          param: :filter_name,
          filter: resources_filter_matches(%i[first_name last_name])
        }]
      )
    end

    # GET /admin/people/:id
    def show
      @person = load_person
    end

    # GET /admin/people/edit/:id
    def edit
      @person ||= load_person
      @person_form ||= person_form
    end

    # PUT /admin/people/:id
    # PATCH /admin/people/:id
    def update
      @person = load_person
      @person_form = person_form

      if @person_form.valid? && @person_form.save
        redirect_to(admin_person_path(@person_form.id))
      else
        render :edit
      end
    end

    # GET /admin/people/new
    def new
      @person ||= Person.new
      @person_form ||= person_form
    end

    # POST /admin/people
    def create
      @person = Person.new
      @person_form = person_form

      if @person_form.valid? && @person_form.save
        redirect_to(admin_person_path(@person_form.id))
      else
        render :new
      end
    end

    # DELETE /admin/people/:id
    def destroy
      @person = Person.new
      name = [@person.last_name, @person.first_name].join(', ')

      @person.destroy # only fails when it raises an exception
      flash[:success] = "Successfully deleted #{name}"

      redirect_to admin_people_path
    end

    # @!group Helpers

    def load_person
      params.require(:id)
      id = params[:id].to_i
      return Person.includes(:groups, :owned_groups).find(id)
    end
    private :load_person

    def person_form
      form = PersonForm.new(@person)
      form.assign_attributes(params.fetch(:person, {}).except(:id))
      return form
    end
    private :person_form

    # @!endgroup
  end
end
