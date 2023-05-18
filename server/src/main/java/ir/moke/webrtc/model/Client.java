package ir.moke.webrtc.model;

import jakarta.websocket.Session;

import java.util.Objects;

public record Client(String cellPhoneNumber, String name, Session session) {
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Client client = (Client) o;
        return Objects.equals(cellPhoneNumber, client.cellPhoneNumber);
    }

    @Override
    public int hashCode() {
        return Objects.hash(cellPhoneNumber);
    }
}
