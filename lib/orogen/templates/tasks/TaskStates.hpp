#ifndef <%= component.name %>_TASKS_STATES
#define <%= component.name %>_TASKS_STATES

namespace <%= component.name %>
{
    <% component.self_tasks.
        find_all(&:extended_state_support?).

        each do |task| %>
    enum <%= task.state_type_name %>
    {
        <% states = task.each_state.to_a
           states.each_with_index do |(state_name, state_type), i| %>
            <%= task.state_global_value_name(state_name, state_type) %><%= ',' if i != states.size - 1 %>
        <% end %>
    };
    <% end %>
}

#endif

