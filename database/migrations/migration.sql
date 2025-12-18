-- Migration SQL Script

-- Drop table if exists
DROP TABLE IF EXISTS `roles`;

-- Create table
CREATE TABLE `roles` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `uuid` CHAR(36) NOT NULL UNIQUE,
    `name` VARCHAR(255) NOT NULL UNIQUE,
    `description` VARCHAR(255) NULL,
    `created_by` BIGINT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_by` BIGINT NOT NULL,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted` TINYINT(1) DEFAULT 0
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Add indexes
CREATE INDEX idx_roles_name ON `roles` (`name`);



-- Drop table if exists
DROP TABLE IF EXISTS `divisions`;

-- Create table
CREATE TABLE `divisions` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `uuid` CHAR(36) NOT NULL UNIQUE,
    `name` VARCHAR(255) NOT NULL UNIQUE,
    `description` VARCHAR(255) NULL,
    `created_by` BIGINT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_by` BIGINT NOT NULL,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted` TINYINT(1) DEFAULT 0
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Add indexes
CREATE INDEX idx_divisions_name ON `divisions` (`name`);



-- Drop table if exists
DROP TABLE IF EXISTS `positions`;

-- Create table
CREATE TABLE `positions` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `uuid` CHAR(36) NOT NULL UNIQUE,
    `name` VARCHAR(255) NOT NULL UNIQUE,
    `description` VARCHAR(255) NULL,
    `created_by` BIGINT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_by` BIGINT NOT NULL,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted` TINYINT(1) DEFAULT 0
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Add indexes
CREATE INDEX idx_positions_name ON `positions` (`name`);



-- Drop table if exists
DROP TABLE IF EXISTS `users`;

-- Create table
CREATE TABLE `users` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `uuid` CHAR(36) NOT NULL UNIQUE,

    `role_id` BIGINT UNSIGNED NOT NULL,
    `division_id` BIGINT UNSIGNED NULL,
    `position_id` BIGINT UNSIGNED NULL,
    `manager_id` BIGINT UNSIGNED NULL,

    `employee_card_id` VARCHAR(255) NOT NULL UNIQUE,
    `first_name` VARCHAR(255) NOT NULL,
    `last_name` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `phone` VARCHAR(255) NULL,
    `address` VARCHAR(255) NULL,
    `photo` VARCHAR(255) NULL,

    `status` ENUM('active', 'inactive') DEFAULT 'active',

    `created_by` BIGINT NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_by` BIGINT NOT NULL DEFAULT 0,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted` TINYINT(1) DEFAULT 0,

    CONSTRAINT `fk_users_role`
        FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),

    CONSTRAINT `fk_users_division`
        FOREIGN KEY (`division_id`) REFERENCES `divisions` (`id`),

    CONSTRAINT `fk_users_position`
        FOREIGN KEY (`position_id`) REFERENCES `positions` (`id`),

    CONSTRAINT `fk_users_manager`
        FOREIGN KEY (`manager_id`) REFERENCES `users` (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Add indexes
CREATE INDEX idx_users_email ON `users` (`email`);



-- Drop table if exists
DROP TABLE IF EXISTS `employee_photos`;

-- Create table
CREATE TABLE `employee_photos` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `uuid` CHAR(36) NOT NULL UNIQUE,
    `user_id` BIGINT UNSIGNED NULL,
    `photo_path` VARCHAR(255) NULL,
    `label` ENUM('front', 'left', 'right', 'closed eyes') NULL,
    `created_by` BIGINT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_by` BIGINT NOT NULL,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted` TINYINT(1) DEFAULT 0,

    CONSTRAINT `fk_employee_photos_user`
        FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Add indexes
CREATE INDEX idx_employee_photos_user_id ON `employee_photos` (`user_id`);



-- Drop table if exists
DROP TABLE IF EXISTS `attendances`;

-- Create table
CREATE TABLE `attendances` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `uuid` CHAR(36) NOT NULL UNIQUE,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `date` DATE NOT NULL,
    `clock_in` DATETIME NULL,
    `clock_out` DATETIME NULL,
    `status` ENUM('ontime', 'late', 'absent') DEFAULT 'ontime',
    `overtime` INT DEFAULT 0,
    `photo_in` VARCHAR(255) NOT NULL,
    `photo_out` VARCHAR(255) NULL,
    `geo_in` VARCHAR(255) NOT NULL,
    `geo_out` VARCHAR(255) NULL,

    `created_by` BIGINT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_by` BIGINT NOT NULL,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted` TINYINT(1) DEFAULT 0,

    CONSTRAINT `fk_attendance_user`
        FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Add indexes
CREATE INDEX idx_attendances_user_id ON `attendances` (`user_id`);



-- Drop table if exists
DROP TABLE IF EXISTS `leave_requests`;

-- Create table
CREATE TABLE `leave_requests` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `uuid` CHAR(36) NOT NULL UNIQUE,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `type` ENUM('leave', 'sick') NOT NULL,
    `reason` VARCHAR(255) DEFAULT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    `status` ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
    `approved_by` BIGINT DEFAULT NULL,
    `created_by` BIGINT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_by` BIGINT NOT NULL,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted` TINYINT(1) NOT NULL DEFAULT 0,

    CONSTRAINT `leave_requests_user_id_fk`
        FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Add indexes
CREATE INDEX idx_leave_requests_user_id ON `leave_requests` (`user_id`);



-- Drop table if exists
DROP TABLE IF EXISTS `leave_balances`;

-- Create table
CREATE TABLE `leave_balances` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `uuid` CHAR(36) NOT NULL UNIQUE,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `year` YEAR NOT NULL,
    `quota` INT NOT NULL DEFAULT 0,
    `used` INT NOT NULL DEFAULT 0,

    `created_by` BIGINT NOT NULL,
    `updated_by` BIGINT NOT NULL,

    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    `deleted` TINYINT(1) NOT NULL DEFAULT 0,

    CONSTRAINT `leave_balances_user_id_fk`
        FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Add indexes
CREATE INDEX idx_leave_balances_user_id ON `leave_balances` (`user_id`);


-- Drop table if exists
DROP TABLE IF EXISTS `password_otps`;

-- Create table
CREATE TABLE `password_otps` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `uuid` CHAR(36) NOT NULL UNIQUE,
    `email` VARCHAR(255) NOT NULL,
    `otp` VARCHAR(255) NOT NULL,
    `expires_at` TIMESTAMP NOT NULL,
    `used` TINYINT(1) NOT NULL DEFAULT 0,

    `created_by` BIGINT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_by` BIGINT NOT NULL,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    `deleted` TINYINT(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Add indexes
CREATE INDEX idx_password_otps_email ON `password_otps` (`email`);

-- End of migration.sql