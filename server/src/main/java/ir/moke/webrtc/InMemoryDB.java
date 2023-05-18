package ir.moke.webrtc;

import ir.moke.webrtc.model.Client;
import jakarta.websocket.Session;

import java.util.Optional;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class InMemoryDB {

    private static final Set<Client> CLIENT_LIST = ConcurrentHashMap.newKeySet();
    public static final InMemoryDB instance = new InMemoryDB();

    private InMemoryDB() {
    }

    public boolean addClient(Client client) {
        return CLIENT_LIST.add(client);
    }

    public void removeClient(Session session) {
        CLIENT_LIST.removeIf(item -> item.session().equals(session));
    }

    public Client getClient(Session session) {
        return CLIENT_LIST.stream().filter(item -> item.session().equals(session)).findFirst().orElse(null);
    }

    public Optional<Client> getClient(String name) {
        return CLIENT_LIST.stream().filter(item -> item.name().equals(name)).findFirst();
    }

    public Set<Client> listClients() {
        return CLIENT_LIST;
    }

    public boolean contain(Session session) {
        return CLIENT_LIST.stream().anyMatch(item -> item.session().equals(session));
    }
}
