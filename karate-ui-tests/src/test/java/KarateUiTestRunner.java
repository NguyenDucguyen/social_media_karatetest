import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.DisplayName;

@DisplayName("Karate UI Test Suite")
public class KarateUiTestRunner {

    /**
     * Executes all feature files in src/test/resources/ui/
     */
    @Karate.Test
    Karate runAllUi() {
        return Karate.run("classpath:ui/").relativeTo(getClass());
    }

    /**
     * Run E2E tests
     * Command: mvn test -Dkarate.options="--tags @e2e
     */
    @Karate.Test
    @DisplayName("E2E Tests")
    Karate runE2ETests() {
        return Karate.run("classpath:e2e/e2e-all-feature.feature").relativeTo(getClass());
    }

    /**
     * Run only registration tests
     * Command: mvn test -Dkarate.options="--tags @register"
     */
    @Karate.Test
    @DisplayName("Register Tests")
    Karate runRegisterTests() {
        return Karate.run("classpath:ui/register.feature").relativeTo(getClass());
    }

    /**
     * Run only login tests
     * Command: mvn test -Dkarate.options="--tags @login"
     */
    @Karate.Test
    @DisplayName("Login Tests")
    Karate runLoginTests() {
        return Karate.run("classpath:ui/login.feature").relativeTo(getClass());
    }

    /**
     * Run only home page tests
     * Command: mvn test -Dkarate.options="--tags @home"
     * @return
     */
    @Karate.Test
    @DisplayName("Home Page Tests")
    Karate runHomePageTests() {
        return Karate.run("classpath:ui/home.feature").relativeTo(getClass());
    }

    /**
     * Run only profile tests
     * Command: mvn test -Dkarate.options="--tags @profile"
     */
    @Karate.Test
    @DisplayName("Profile Tests")
    Karate runProfileTests() {
        return Karate.run("classpath:ui/profile.feature").relativeTo(getClass());
    }

    /**
     * Run only posts tests
     * Command: mvn test -Dkarate.options="--tags @posts"
     */
    @Karate.Test
    @DisplayName("Posts Tests")
    Karate runPostsTests() {
        return Karate.run("classpath:ui/posts.feature").relativeTo(getClass());
    }
}
   