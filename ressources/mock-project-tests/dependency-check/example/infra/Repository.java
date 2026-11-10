package example.infra;

import example.domain.Order;

public class Repository {

    public Order load() {
        return new Order();
    }
}
