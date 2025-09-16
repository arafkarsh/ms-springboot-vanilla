-- cart_es_view_tx: one row per cart
-- DROP TABLE ms_schema.cart_es_view_tx;
CREATE TABLE IF NOT EXISTS ms_schema.cart_es_view_tx (
  cart_id      VARCHAR(255)  PRIMARY KEY,
  checked_out  BOOLEAN      NOT NULL DEFAULT FALSE,
  total        NUMERIC(18,2) NOT NULL DEFAULT 0
);

ALTER TABLE ms_schema.cart_es_view_tx OWNER TO msadm;

-- cart_es_view_items_tx: items per cart
-- DROP TABLE ms_schema.cart_es_view_items_tx;
CREATE TABLE IF NOT EXISTS ms_schema.cart_es_view_items_tx (
  id          BIGSERIAL      PRIMARY KEY,
  cart_id     VARCHAR(255)    NOT NULL,
  product_id  VARCHAR(128)   NOT NULL,
  quantity    INTEGER        NOT NULL,
  unit_price  NUMERIC(18,2)  NOT NULL,
  line_total  NUMERIC(18,2)  NOT NULL,
  CONSTRAINT uk_cart_item UNIQUE (cart_id, product_id),
  CONSTRAINT fk_item_cart FOREIGN KEY (cart_id)
      REFERENCES cart_es_view_tx(cart_id) ON DELETE CASCADE
);

ALTER TABLE ms_schema.cart_es_view_items_tx OWNER TO msadm;

CREATE INDEX IF NOT EXISTS idx_cart_item_cartid ON ms_schema.cart_es_view_items_tx(cart_id);
