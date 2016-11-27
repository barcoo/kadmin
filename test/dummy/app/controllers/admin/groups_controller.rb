# frozen_string_literal: true
module Admin
  class GroupsController < Admin::ApplicationController
    # Maximum page size for a given pager
    MAX_PAGE_SIZE = 1000

    self.navbar_section = self

    # GET /admin/groups
    def index
      params.permit(:page_size, :page_offset, :filter_name, :format)

      page_size = [params.fetch(:page_size, 50).to_i, MAX_PAGE_SIZE].min

      finder = Kadmin::Finder.new(Group.eager_load(:people, :owner).order(created_at: :desc))
        .filter(name: :name, column: [:name], value: params[:filter_name])
        .paginate(size: page_size, offset: params.fetch(:page_offset, 0))
      finder.find!
      @finder = finder.present

      respond_to do |format|
        format.html
        format.js do
          render json: {
            items: @finder.results.map(&:attributes),
            more: @finder.pager.next_page?
          }
        end
      end
    end

    # GET /admin/groups/:id
    def show
      @group = load_group
    end

    # GET /admin/groups/edit/:id
    def edit
      @group ||= load_group
      @group_form ||= group_form
    end

    # PUT /admin/groups/:id
    # PATCH /admin/groups/:id
    def update
      @group = load_group
      @group_form = group_form

      if @group_form.valid? && @group_form.save
        redirect_to(admin_group_path(@group_form.id))
      else
        render :edit
      end
    end

    # GET /admin/groups/new
    def new
      @group ||= Group.new
      @group_form ||= group_form
    end

    # POST /admin/groups
    def create
      @group = Group.new
      @group_form = group_form

      if @group_form.valid? && @group_form.save
        redirect_to(admin_group_path(@group_form.id))
      else
        render :new
      end
    end

    # DELETE /admin/groups/:id
    def destroy
      @group = load_group
      name = @group.name

      @group.destroy # only fails when it raises an exception
      flash[:success] = "Successfully deleted #{name}"

      redirect_to admin_groups_path
    end

    # @!group Helpers

    def load_group
      params.require(:id)
      id = params[:id].to_i
      return Group.eager_load(:people, :owner).find(id)
    end
    private :load_group

    def group_form
      # Make sure associated forms have a model too
      @group.owner ||= Person.new
      form = GroupForm.new(@group)
      form.assign_attributes(params.fetch(:group, {}).except(:id))
      return form
    end
    private :group_form

    # @!endgroup
  end
end
