package vn.edu.ute.config;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SiteMeshConfig {

    @Bean
    public FilterRegistrationBean<ConfigurableSiteMeshFilter> siteMeshFilter() {
        FilterRegistrationBean<ConfigurableSiteMeshFilter> filter = new FilterRegistrationBean<>();
        
        ConfigurableSiteMeshFilter sitemesh = new ConfigurableSiteMeshFilter() {
            @Override
            protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
                // Decorator cho trang Admin
                builder.addDecoratorPath("/admin/*", "/WEB-INF/views/decorators/admin.jsp");
                
                // Decorator mặc định cho User và các trang khác (Giỏ hàng, Đơn hàng, v.v.)
                builder.addDecoratorPath("/*", "/WEB-INF/views/decorators/user.jsp")
                       // Loại trừ các trang không cần decorator
                       .addExcludedPath("/login*")
                       .addExcludedPath("/register*")
                       .addExcludedPath("/api/*")
                       .addExcludedPath("/static/*")
                       .addExcludedPath("/resources/*");
            }
        };

        filter.setFilter(sitemesh);
        filter.addUrlPatterns("/*");
        filter.setName("sitemeshFilter");
        filter.setOrder(1);
        return filter;
    }
}