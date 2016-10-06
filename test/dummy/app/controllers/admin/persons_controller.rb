module Admin
  class PersonsController < Admin::ApplicationController
    MAX_PAGE_SIZE = 200

    # GET /admin/jobs
    def index
      params.permit(:page_size, :page_offset, :filter_name, :format)

      page_size = [params.fetch(:page_size, 15).to_i, MAX_PAGE_SIZE].min # fix 200 as maximum size

      @finder = Kadmin::Finder.new(Kadmin::Person.includes(:groups, :owned_groups).order(created_at: :desc))
      @persons = @finder.filter(name: :name, column: [:first_name, :last_name], value: params[:filter_name])
        .paginate(size: page_size, offset: params.fetch(:page_offset, 0))
        .find
        .decorate
    end

    # GET /admin/persons/:id
    def show
      @person = load_person
    end

    # GET /admin/persons/edit/:id
    def edit
      @person ||= load_person
      @person_form ||= person_form
    end

    # PUT /admin/persons/:id
    # PATCH /admin/persons/:id
    def update
      @person = load_person
      @person_form = person_form

      if form.valid?
        redirect_to(admin_person_path(person.id))
      else
        edit
      end
    end

    # GET /admin/persons/new
    def new
      @person ||= Person.new
      @person_form ||= person_form
    end

    # POST /admin/persons
    def create
      @person = Person.new
      @person_form = person_form

      if @person_form.valid?
        redirect_to(admin_person_path(@person.id))
      else
        new
      end
    end

    # DELETE /admin/persons/:id
    def destroy
      @person = Person.new
      name = [@person.last_name, @person.first_name].join(', ')

      @person.destroy # only fails when it raises an exception
      flash[:success] = "Successfully deleted #{name}"

      redirect_to admin_persons_path
    end

    # @!group Helpers

    def load_person
      params.require(:id)
      id = params[:id].to_i
      return Person.includes(:groups, :owned_groups).find(id)
    end
    private :load_job

    def person_form
      return Forms::PersonForm.new(@person)
    end
    private :person_form

    # @!endgroup
  end
end
