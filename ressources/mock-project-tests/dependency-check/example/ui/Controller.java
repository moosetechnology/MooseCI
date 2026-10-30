package example.ui;

import example.infra.Repository;
import example.domain.Order;

public class Controller {

    private Repository repository;

    public Order get(int id) {
        return repository.load();
    }
}
